# Fuzzware P2IM unit test adherence testing
In this experiment we test whether fuzzware is able to pass the unit tests which were [originally introduced by P2IM](https://github.com/RiS3-Lab/p2im-unit_tests).

## Running the experiment
Invocation: `./run_experiment.sh`

## Expected Result
At the end, the following should be output via stdout:
```
Got 66 successes and 0 failures
```

## Computation Resources
Runtime: <= 24h on a single instance.
RAM: 4GB RAM per parallel instance (1-2GB per instance could suffice as well)

Estimated Run Time details:
For this experiment, each one of the 46 samples is run for 15 minutes, and then traces are generated for each sample.

With a single fuzzing instance, fuzzing will require ~12 hours, with additional run-time for full trace generation. Overall, the experiment should conclude within 24 hours maximum.

The fuzzing stage can be sped up by multiprocessing. Fuzzing multiple targets at once can be enabled by specifying how many instances to run in parallel as an argument to `./run_fuzzers.sh`.

## Groundtruth
To be able to test whether unit tests are passed, we generated the required ground truth by first analyzed each sample and determined which coverage is required to occur (possibly with additional ordering requirements) to indicate that a given test case has been passed.

We express the coverage requirements as ground-truth per test case in the following CSV (more specifically, tab-separated) format:

`<Target File Path> <Testcase Type (Read/Write/IRQ)> <Coverage Requirements> <Note about requirement>`

To express information about alternative coverage and ordered coverage, we use the following syntax for the `Coverage Requirements` field:

1. `0xdeadbeef`: Address `0xdeadbeef` has to be covered
2. `mysym`: Address which represents symbol `mysym` has to be covered.
3. `0xdeadbeef -> mysym`: A trace must exist where first `0xdeadbeef` is reached, then `mysym`.
4. `0xdeadbeef || mysym`: A trace must exist where either `0xdeadbeef` is reached, or `mysym` is reached.
5. `0xdeadbeef || mysym -> mysym2`: A trace must exist where either `0xdeadbeef` is reached, or where `mysym` and then `mysym2` is reached.

## Test Procedure
Fuzzware's configuration files (`config.yml` as well as `*.bin`) have been auto-generated for the targets via the `fuzzware genconfig` utility.

The experiment is performed in the following steps:
1. Run 15-minute fuzzing runs on each target and generate basic block traces. This is done via `./run_fuzzers.sh [<number_of_concurrent_procs>]`
2. Check the resulting coverage against the ground truth CSV via `check_results.py groundtruth_expected_p2im_testcase_behavior.csv`

The checks are implemented based on the traces that can be generated by Fuzzware via the `fuzzware gentraces` utility.

To be able to more easily read the ground truth, you may copy the groundtruth entries into a google docs sheet.
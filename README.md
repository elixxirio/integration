# Integration

## Purpose
This is to automatically test all the system's components and make sure they 
work together correctly. If the integration test passes, it should guarantee
that clients can send messages all the way through the system, including 
mixing with multiple nodes and an anonymity set greater than 1. If the 
integration test fails, look at the logs and narrow down the cause by adding
more logging statements if necessary.

## How to manually run locally

1. Build the binaries under test for your operating system and place them in 
the `bin` directory.
1. `cd` to `basice2e/` and run `run.sh`. Observe the results and inspect the 
logs if things go wrong.
1. Make changes to the `run.sh` script, config files, and binaries as needed
based on your analysis of the logs. You may want to add more logging or build
the binaries under test with race condition checking to track down problems.

## What runs on continuous integration?

The `master` branch of integration runs whenever you merge anything to the 
`master` branch of any of the projects that integration tests. The CI server 
downloads the latest `master` branch binaries that any CI server built and 
uses them to run `basice2e/run.sh`.

The benchmark branch of integration runs nightly and produces information about
how fast the software runs. It doesn't provide the full performance picture 
because it runs on one modest CI server, rather than on a team of powerful 
servers. However, the information it provides is sometimes useful.

So, if you make changes that break integration and merge the fixes to the 
`master` branch of integration, you ought to also merge the `master` branch
into the `benchmark` branch so that the benchmarks will continue to function.

## Automate running locally

`build.sh` generates version information for all repositories under test and
builds binaries for them in the `bin/` directory.

`update.sh` runs `git pull` for each repo under test, and by uncommenting the
relevant code, checks out the `master` branch of each repo before pulling. This 
is the most useful if you're trying to fix an integration breakage in 
`master` and you want to get started right away.

In the root directory of integration, `run.sh` builds new binaries with
`build.sh`, runs the `basice2e` integration test, and opens all the log files
in `gedit` for easy viewing.  If you prefer some other program to view the
resulting logs, set the INTEGRATION\_EDITOR environment variable:

`INTEGRATION_EDITOR=emacs ./run.sh`

If you need to make a lot of exploratory changes to get things integrated,
using these utility scripts can speed up the process.


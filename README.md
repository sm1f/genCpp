This is intended as a empty cpp app, used to start writing new apps.


Idea for bug tracking

bug treck:

0: Developer tests
   test being developed or use by the developer at this time.

1: Smoke tests: less than 1 min.

2: Fast regression tests: should take less than time to get coffee
   These are resent tests, plus tests that recently had problems,
   plus tests with high risk of failing (not already included
   in early tests).

3: dev check in tests: less than 1 hour
   These are tests that should pass before check in to develement

4: release check in tests: tests that are needed for release

5: weekend tests:  can take take up to 60 hours to run


?: manual tests:
   Require a user to perform actions.

?: shotgun tests: run for as long as time limit, otherwise would run forever
   These are used to find memory leaks, and edge cases that noone thought of.
   Uses random number to create parameters, often results are hard to check

?: timing tests:
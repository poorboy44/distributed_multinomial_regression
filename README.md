# distributed_multinomial_regression

Testing out Taddy's distrom package on some real data.

Steps:
- Pulled bios of moms on Twitter (~1M).
- Created the DTM in Python Scikit-learn and exported in Market Matrix format (tried using tm & quanteda R packaes for this but they kept bombing out)
- Read in DTM to R and run DMR. Word ~ f(state)
- Plot over/under index terms: CA vs NY, CA vs CO etc.  The regressions normalize each word to the same unit interval so we can compare relative popularity of words in each state, controlling for overall popularity, gender, etc.
- Plan to extend this so I can isolate the time trend for each word, controlling for the changing composition of the underlying user base.

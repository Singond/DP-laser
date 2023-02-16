LIF 2023-01-20
==============

Spectral scans
--------------
Wavelength is varied by tuning the laser.
Initially without spatial filter, added with `scan9`.

Starting from `scan13`, the powermeters are swapped.
The higher-resolution powermeter is now right behind the splitter,
the other one is unused.
If the intensity of the reflected beam is needed, it has to be estimated
based on the correspondence between the powermeters in previous datasets.

```
name    from[nm]  step[nm]  to[nm]  amp  notes
scan1   195.8     0.005     196.2   50
scan2   195.95    0.001     196.2   50   Error, ran out of selenium during measurement
scan3   195.95    0.001     196.2   50   Detected some extra minor peaks, repeating
scan4   195.95    0.001     196.2   50
scan5   195.95    0.001     196.2   40
scan6   195.95    0.001     196.2   30
scan7   195.95    0.001     196.2   20
scan8   195.95    0.001     196.2   13
scan9   195.95    0.001     196.2   50   Added spatial filter.
scan10  195.95    0.001     196.2   40
scan11  195.95    0.001     196.2   30
scan12  195.95    0.001     196.2   24
scan13  195.95    0.001     196.2   15   Swapped powermeters.
```

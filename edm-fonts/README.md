EDM yum files

These are required on the host workstation rendering EDM
screens since EDM uses local fonts.

At DLS these are usually pre-installed on workstations.

As part of the RHEL8 updates, these RPMs have been modified for distribution to both RHEL7 and RHEL8 machines using satellite. These are now being held in a private repository by scientific computing. Too see if you have the fonts installed, run:
```
yum list installed | grep dls-
```
You should see:
- dls-courier
- dls-arial
- dls-msttcore


Install with:

```bash
bash <(curl -s https://github.com/dls-controls/dev-c7/raw/main/edm-fonts/install-fonts.sh)
```
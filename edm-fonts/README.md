# EDM yum files

These are required on the host workstation rendering EDM
screens since EDM uses local fonts.

At DLS these are usually pre-installed on workstations.

As part of the RHEL8 updates, these RPMs have been modified for distribution to both RHEL7 and RHEL8 machines using satellite. The modified RPMs are now being held in a private repository by scientific computing. To see if you have the fonts installed, run:

```bash
yum list installed | grep dls-
```

You should see:

- dls-courier
- dls-arial
- dls-msttcore

In a scenario where this package is not avaiable, installing the fonts provided here is a suitable alternative.

Install with:

```bash
bash <(curl -s https://github.com/dls-controls/dev-c7/raw/main/edm-fonts/install-fonts.sh)
```

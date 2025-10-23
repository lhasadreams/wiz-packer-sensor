# wiz-packer-sensor
Packer template to create an AMI with the Wiz Sensor

```hcl
packer build -var-file="secrets.pkrvars.hcl"  wiz.sensor.pkr.hcl
```
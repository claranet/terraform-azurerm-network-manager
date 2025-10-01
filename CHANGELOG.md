## 8.0.1 (2025-10-01)

### Code Refactoring

* **deps:** 🔗 update claranet/azurecaf to ~> 1.3.0 🔧 bcfa3ff

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review b4e20d3
* 🗑️ remove old commitlint configuration files 5cec407
* **deps:** 🔗 bump AzureRM provider version to v4.31+ 6ed9e6a
* **deps:** update dependency claranet/diagnostic-settings/azurerm to ~> 8.1.0 439bf9a
* **deps:** update dependency opentofu to v1.10.0 6f438a5
* **deps:** update dependency opentofu to v1.10.1 2416de6
* **deps:** update dependency opentofu to v1.10.3 9f22965
* **deps:** update dependency opentofu to v1.10.6 0a2b066
* **deps:** update dependency opentofu to v1.9.0 1e72477
* **deps:** update dependency opentofu to v1.9.1 3691858
* **deps:** update dependency pre-commit to v4.1.0 1524fb3
* **deps:** update dependency pre-commit to v4.2.0 6c63588
* **deps:** update dependency terraform-docs to v0.20.0 5548830
* **deps:** update dependency tflint to v0.55.0 077bf09
* **deps:** update dependency tflint to v0.57.0 3af6eb0
* **deps:** update dependency tflint to v0.58.0 5caa6f6
* **deps:** update dependency tflint to v0.58.1 6217569
* **deps:** update dependency tflint to v0.59.1 4423af5
* **deps:** update dependency trivy to v0.58.2 bafbd87
* **deps:** update dependency trivy to v0.59.1 25e51aa
* **deps:** update dependency trivy to v0.60.0 4ebce2c
* **deps:** update dependency trivy to v0.61.1 2679d25
* **deps:** update dependency trivy to v0.62.0 e7b1de1
* **deps:** update dependency trivy to v0.62.1 a953579
* **deps:** update dependency trivy to v0.63.0 cc62ec2
* **deps:** update dependency trivy to v0.66.0 ebb8890
* **deps:** update dependency trivy to v0.67.0 6ca6858
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 247ba73
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 f7fbabb
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v6 ff299b9
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 b9b227b
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 7a4804e
* **deps:** update terraform claranet/diagnostic-settings/azurerm to ~> 8.2.0 6d7977e
* **deps:** update tools b4c41c9
* **deps:** update tools 9a062f9
* **deps:** update tools 77fa12e
* **deps:** update tools d3039d7
* **deps:** update tools 278e428
* update Github templates b7d55f6
* update tflint config for v0.55.0 17b30ad

## 8.0.0 (2025-01-09)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** add custom Network security admin rule (and collections) ddc1efa
* **AZ-1088:** change default rules priority (admin ones) b868248
* **AZ-1088:** module v8 structure and updates 365f81d
* register Network Manager at Management group level 93abf80

### Bug Fixes

* **AZ-1088:** add some postconditions checks for config deployments 500da88
* **AZ-1088:** change default naming, no need to set env/region 07d15e7
* default collection rule should be crated only when default a6ce664
* multiple vnet member in network group for_each 432d7a7
* triggers config deployment in case of variable changes 14e7d4b
* update depends_on, ensure everything is created before deploying 7f1b2fb

### Code Refactoring

* add `direct_connectivity_enabled` simplified attributed d214f6a

### Miscellaneous Chores

* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 dd22daa
* **deps:** update dependency claranet/diagnostic-settings/azurerm to v8 45cb977
* **deps:** update dependency opentofu to v1.8.3 3112088
* **deps:** update dependency opentofu to v1.8.4 17d0b89
* **deps:** update dependency opentofu to v1.8.6 df2d574
* **deps:** update dependency opentofu to v1.8.8 2db4274
* **deps:** update dependency pre-commit to v4 dfbb051
* **deps:** update dependency pre-commit to v4.0.1 0a186b2
* **deps:** update dependency tflint to v0.54.0 47f8ebd
* **deps:** update dependency trivy to v0.56.0 54c5703
* **deps:** update dependency trivy to v0.56.1 01aa0fe
* **deps:** update dependency trivy to v0.56.2 0888084
* **deps:** update dependency trivy to v0.57.1 5430121
* **deps:** update dependency trivy to v0.58.1 c23f92f
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 39566df
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 a9eb298
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 a2d2067
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 c741cb3
* **deps:** update tools 0c47e7b
* **deps:** update tools c24292b
* prepare for new examples structure 44f9cc9
* update examples structure eb65526

## 7.1.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 99b8cf6

### Documentation

* update README badge to use OpenTofu registry e17ffec
* update README with `terraform-docs` v0.19.0 ef80176

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 2c7e160
* **deps:** update dependency opentofu to v1.8.0 a1d630a
* **deps:** update dependency opentofu to v1.8.1 5a49033
* **deps:** update dependency pre-commit to v3.8.0 5d0386d
* **deps:** update dependency terraform-docs to v0.19.0 3e0a814
* **deps:** update dependency tflint to v0.52.0 6ab3a1a
* **deps:** update dependency tflint to v0.53.0 4a4e010
* **deps:** update dependency trivy to v0.53.0 5238ab4
* **deps:** update dependency trivy to v0.55.0 98c3504
* **deps:** update dependency trivy to v0.55.1 56a8bff
* **deps:** update dependency trivy to v0.55.2 c289859
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 670ce35
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 34c43d9
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 4ed1edd
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 5268193
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 0f2ae6e
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 6ce3f79
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 c3bfc30
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 ed4f9e4
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 09073b7
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 cdc2ef3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 ed39d8a
* **deps:** update tools 92d7e82
* **deps:** update tools d27ff80

## 7.0.1 (2024-07-05)


### Bug Fixes

* update CHANGELOG c790886


### Miscellaneous Chores

* **deps:** update dependency tflint to v0.51.2 907c14b

## 7.0.0 (2024-07-05)


### Features

* **AZ-1427:** add Network manager main features and resources af002ae
* **AZ-1427:** module Azure Network Manager initialization ab3651a
* **AZ-1427:** module Network Manager c24d5a6


### Documentation

* **AZ-1427:** update example b274af5


### Code Refactoring

* apply review suggestions f5368ed


### Miscellaneous Chores

* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 26e4b7e

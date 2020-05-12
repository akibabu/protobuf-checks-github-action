# protobuf-checks-github-action

## Usage
```yaml
name: Protobuf Checks

on:
  pull_request:
    branches: master

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
    
    - name: Master checkout
      uses: actions/checkout@v2
      with:
        ref: "master"
        path: "master"

    - name: Branch checkout
      uses: actions/checkout@v2
      with:
        path: "branch"
    
    - name: Protobuf Checks
      uses: akibabu/protobuf-checks-github-action@master
      with:
          checkouts_dir: ${{github.workspace}}
      env:
        GITHUB_ACCESS_TOKEN: ${{secrets.GITHUB_TOKEN}}
```

# grimm

## Requirements

*   [exist-db](http://exist-db.org/exist/apps/homepage/index.html) version: `5.x` or greater

*   [ant](http://ant.apache.org) version: `1.10.7` \(for building from source\)

*   [node](http://nodejs.org) version: `12.x` \(for building from source\)

### Building from source

1. Download, fork or clone this GitHub repository
2. Call `ant`
```bash
cd grimm
ant
```
3. Download, fork or clone the GitHub repository with the data package: https://github.com/unil-lettres/grimm-data
4. Call `ant` to build the package
```bash
cd grimm-data
ant
```

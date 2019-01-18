# NitroxBuild
 A docker image that builds Nitrox

### Environment
Mono: mono-complete latest (5.18.0.225) with MSBuild&nuget

Unity: UnityEditor 5.6.2f1

### Notice
All projects are supported but NitroxTest due to the missing of Test Utils dependency .

### Usage
```
# example

image=dkingchn/nitroxbuild
NitroxPath="$HOME/Nitrox"
SubnauticaPath="$HOME/Subnautica"

docker pull $image

docker run -it --rm \
    -v "$SubnauticaPath":/opt/Subnautica \
    -v "$NitroxPath":/opt/Nitrox \
    $image

```


### Explaination of dockerfile content
1. Why not build it based on `mono:latest`\
    UnityEditor=5.6.2f1 requires many ubuntu-only dependencies
2. Why not build it based on `gableroux/unity3d:5.6.2f1`\
    gableroux/unity3d is installed with mono 2.6.x.
3. Why mono latest(5.0+)\
    To parse VS2017 .sln/.csproj files, we do need it. Older mono won't work.


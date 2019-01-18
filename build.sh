#!/bin/bash

# check existence of dirs
if [ ! -d /opt/Nitrox ]; then
    echo Please mount Nitrox source directory to /opt/Nitrox
    exit 1
fi

if [ ! -d /opt/Subnautica ]; then
     echo Please mount Subnautica game directory to /opt/Subnautica
     exit 1
fi

cd /opt/Nitrox

# update game path
cp DevVars.targets.example DevVars.targets
sed -i 's/C:\\Program Files\\Epic Games\\Subnautica/\/opt\/Subnautica/g' DevVars.targets
grep SubnauticaDir DevVars.targets

# hope this fixes most case and FS path problems
export MONO_IOMAP=all

# exclude NitroxTest on build (linux does not support test utils)
NT_guid=`grep NitroxTest Nitrox.sln | cut -d ' ' -f 5 | sed -e 's/[\r\n"]//g'`
disable_nt="\t\t${NT_guid}.Release|Any CPU.Build.0 = Release|Any CPU"
sed -i '/'${NT_guid}'.Release|Any\ CPU.Build.0/d' Nitrox.sln

nuget restore Nitrox.sln
msbuild /p:Configuration=Release Nitrox.sln

# restore Nitrox.sln
sed -i '/'${NT_guid}'.Release|Any\ CPU.ActiveCfg/a\\t\t'${NT_guid}'.Release|Any\ CPU.Build.0\ =\ Release|Any\ CPU' Nitrox.sln

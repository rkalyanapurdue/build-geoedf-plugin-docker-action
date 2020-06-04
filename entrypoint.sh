#!/bin/bash -l

cd /github/workspace 

changed_files=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA)

indx=0
declare -a res

for path in $changed_files
do
  if [ `basename $path` != $path ]
  then
      val=$(echo $path | tr "/" "\n" | head -1)
      res[indx]=$val
      ((indx++))
  fi
done
echo "::set-output name=folders::${res[*]}"

hpccm --recipe recipe.hpccm --format singularity > Singularity.def

singularity build image.sif Singularity.def

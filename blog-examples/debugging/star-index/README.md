
To test this:

  mkdir rnaseq
  cd rnaseq
  wget --mirror --no-parent --no-host --cut-dirs=1 https://download.jutro.arvadosapi.com/c=9178fe1b80a08a422dbe02adfd439764+925/
  cd ..

Then:

   arvados-cwl-runner STAR-index-broken.cwl STAR-index.yml

or:

   arvados-cwl-runner STAR-index.cwl STAR-index.yml


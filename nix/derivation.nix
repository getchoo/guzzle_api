{
  lib,
  buildPythonPackage,
  flit-core,
  fastapi,
  pydantic,
  uvicorn,
  self,
  version,
}:
buildPythonPackage {
  pname = "guzzle-api";
  inherit version;

  src = lib.cleanSource self;
  format = "flit";
  doCheck = false;

  propagatedBuildInputs = [fastapi pydantic uvicorn];
  propagatedNativeBuildInputs = [flit-core];
}

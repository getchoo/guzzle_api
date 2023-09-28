{
  lib,
  buildPythonPackage,
  flit-core,
  fastapi,
  pydantic,
  uvicorn,
  self,
}:
buildPythonPackage {
  pname = "guzzle-api";
  version = builtins.substring 0 8 self.lastModifiedDate or "dirty";

  src = lib.cleanSource self;
  format = "pyproject";
  doCheck = false;

  propagatedBuildInputs = [fastapi pydantic uvicorn];
  nativeBuildInputs = [flit-core];
}

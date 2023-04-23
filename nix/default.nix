{
  lib,
  python311Packages,
  version,
}:
python311Packages.buildPythonPackage {
  pname = "guzzle-api";
  inherit version;

  src = lib.cleanSource ../.;
  format = "flit";
  doCheck = false;

  propagatedBuildInputs = with python311Packages; [fastapi pydantic uvicorn];
  propagatedNativeBuildInputs = with python311Packages; [flit-core];
}

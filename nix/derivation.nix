{
  lib,
  buildPythonPackage,
  flit-core,
  fastapi,
  pydantic,
  uvicorn,
  self,
  build,
  wheel,
}:
buildPythonPackage {
  pname = "guzzle-api";
  version = builtins.substring 0 8 self.lastModifiedDate or "dirty";

  src = lib.cleanSource self;
  format = "flit";
  doCheck = false;

  dontUsePypaBuild = true;

  # TODO: find out what's going on with pypaBuildHook
  buildPhase = ''
    runHook preBuild
    pyproject-build --no-isolation --outdir dist/ --wheel $pypaBuildFlags
    runHook postBuild
  '';

  propagatedBuildInputs = [fastapi pydantic uvicorn];
  nativeBuildInputs = [flit-core build wheel];
}

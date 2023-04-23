{
  writeShellApplication,
  python311,
  guzzle-api,
  ...
}:
writeShellApplication {
  name = "guzzle-api-server";
  runtimeInputs = [(python311.withPackages (p: [p.uvicorn guzzle-api]))];
  text = ''
    uvicorn guzzle_api.api:app "$@"
  '';
}

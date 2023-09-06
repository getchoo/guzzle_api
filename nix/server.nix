{
  writeShellApplication,
  python,
  uvicorn,
  guzzle-api,
}:
writeShellApplication {
  name = "guzzle-api-server";
  runtimeInputs = [(python.withPackages (_: [uvicorn guzzle-api]))];
  text = ''
    uvicorn guzzle_api.api:app "$@"
  '';
}

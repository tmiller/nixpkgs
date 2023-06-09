{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, freezegun
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiorecollect";
  version = "2022.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-JIh6jr4pFXGZTUi6K7VsymaCxCrTNBevk9xo9TsrFnM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "aiorecollect"
  ];

  meta = with lib; {
    description = "Python library for the Recollect Waste API";
    longDescription = ''
      aiorecollect is a Python asyncio-based library for the ReCollect
      Waste API. It allows users to programmatically retrieve schedules
      for waste removal in their area, including trash, recycling, compost
      and more.
    '';
    homepage = "https://github.com/bachya/aiorecollect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, cryptography
, mock
, msal
, msal-extensions
, msrest
, msrestazure
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "azure-identity";
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-yTHCcwH/qGsHtNz1dOKdpz4966mrXR/k9EW7ajEX4mA=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    cryptography
    mock
    msal
    msal-extensions
    msrest
    msrestazure
    six
  ];

  pythonImportsCheck = [
    "azure.identity"
  ];

  # Requires checkout from mono-repo and a mock account:
  # https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/identity/tests.yml
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Identity Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}

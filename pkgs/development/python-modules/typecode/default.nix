{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, attrs
, pdfminer-six
, commoncode
, plugincode
, binaryornot
, typecode-libmagic
, pytestCheckHook
, pytest-xdist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typecode";
  version = "30.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Glc5QiTVr//euymeNTxGN+FVaOEa6cUxHGyGo9bQrJc=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    pdfminer-six
    commoncode
    plugincode
    binaryornot
    typecode-libmagic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    "TestFileTypesDataDriven"
    # AssertionError: assert 'application/x-bytecode.python'...
    "test_compiled_python_1"
    "test_package_json"
  ];

  pythonImportsCheck = [
    "typecode"
  ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/nexB/typecode";
    changelog = "https://github.com/nexB/typecode/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

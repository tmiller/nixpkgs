{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, ghostscript
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydyf";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tEo4hV1+R7dAs80xq2Oi9bmyeTkx1QsMyu07t7hpEvw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    ghostscript
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydyf"
  ];

  meta = with lib; {
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprecenth ];
  };
}

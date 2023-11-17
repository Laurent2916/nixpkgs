{ lib
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, buildPythonPackage
, black
, gitpython
, tqdm
, pyyaml
, packaging
, nbformat
, huggingface-hub
, timm
, transformers
, torch
, tokenizers
, google-api-python-client
, pytest-xdist
}:

buildPythonPackage {
  pname = "hf-doc-builder";
  version = "unstable-2023-11-16";
  format = "setuptools";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "doc-builder";
    rev = "c4e348ea1c844d659c65261d914e9cb9237a84e3";
    hash = "sha256-T0YXljux7NSLNRD3FBuenn5pE22CZtIHkkL+/+GWk24=";
  };

  nativeBuildInputs = [
    black
    gitpython
    tqdm
    pyyaml
    packaging
    nbformat
    huggingface-hub
  ];

  nativeCheckInputs = [
    pytestCheckHook
    timm
    transformers
    torch
    tokenizers
    google-api-python-client
    pytest-xdist
  ];

  pythonImportsCheck = [ "doc_builder" ];

  preCheck = ''
    # for `ConvertMdToMdxTester::test_convert_include` and `ConvertMdToMdxTester::test_convert_literalinclude` tests
    # tests expect pytest's `rootdir` not to be a subdirectory of $TMPDIR
    # see https://github.com/huggingface/doc-builder/blob/c4e348ea1c844d659c65261d914e9cb9237a84e3/src/doc_builder/convert_md_to_mdx.py#L160
    export TMPDIR=$TMPDIR/tmpdir/
    mkdir -p $TMPDIR
  '';

  disabledTests = [
    # assert fails
    # see https://github.com/huggingface/doc-builder/blob/c4e348ea1c844d659c65261d914e9cb9237a84e3/tests/test_autodoc.py#L178
    "test_get_type_name"

    # requires internet access
    # see https://github.com/huggingface/doc-builder/blob/c4e348ea1c844d659c65261d914e9cb9237a84e3/src/doc_builder/external.py#L110
    "test_resolve_links_in_text_other_docs"
  ];

  meta = with lib; {
    description = "The package used to build the documentation of our Hugging Face repos";
    homepage = "https://github.com/huggingface/doc-builder";
    license = licenses.asl20;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}

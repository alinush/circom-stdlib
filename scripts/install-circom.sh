tmpdir=`mktemp -d`

cd $tmpdir/
git clone https://github.com/iden3/circom
cd circom/
#git switch -d v2.2.2
# NOTE: This commit solves a tag propagation issue that I found. Eventually, 2.2.3 will be cut.
git checkout de2212a7aa6a070c636cc73382a3deba8c658ad5
cargo build --release
cargo install --path circom

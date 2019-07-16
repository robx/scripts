# call like
#   fetch elm/browser 1.0.1

fetch() { 
    mkdir -p $1;
    mkdir tmp;
    curl -L https://github.com/$1/archive/$2.tar.gz | ( cd tmp; tar xz );
    mv tmp/* $1/$2;
    rm -r tmp
}

# and to populate a dependency directory:

fetchall() {
    grep / ../elm.json | tr -d '":,' | while read a b; do fetch $a $b; done
}


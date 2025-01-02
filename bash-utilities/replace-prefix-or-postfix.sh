#!/usr/bin/env bash

replacer () {
    if [[ $1 == "--help" ]]; then
        cat <<EOF
replacer [--help] [prefix|postfix] <prefix> <postfix> <replacement>

WHERE:
[prefix/postfix] - choose whether prefix or postfix should get replaced
<prefix> - prefix to match
<postfix> - postfix to match
<replacement> - either a prefix or postfix. Leave empty if you want to replace with nothing.

Script to replace prefix or postfix of a given resource reference.
It may look overcomplicated, but it's to accomplish more sophisticated matches
such as replacements of prefixes in references which are for .pdf files only. 

Example usage:

replacer prefix /img/ .pdf

will find and transform a reference such as:

![](/img/customer-analytics/PLS-SEM_II-Evaluation-of-reflective-measurement-models.pdf)

into:

![](customer-analytics/PLS-SEM_II-Evaluation-of-reflective-measurement-models.pdf)
EOF
        exit 0
    fi

    # assume running in project's root directory
    escaped_prefix=$(printf '%s' "$2" | sed 's|[][{}()\.*^$+?|]|\\&|g')
    escaped_postfix=$(printf '%s' "$3" | sed 's|[][{}()\.*^$+?|]|\\&|g')
    escaped_replacement=$(printf '%s' "$4" | sed 's|[][{}()\.*^$+?|]|\\&|g')

    if [[ $1 == "prefix" ]]; then
        echo "option 1"
        find ./notes -name "*.md" -exec sed -i -E \
        -e "s|$escaped_prefix([a-zA-Z0-9_\/\-]+)$escaped_postfix|$escaped_replacement\1$escaped_postfix|g" {} +
        echo "s|$escaped_prefix([a-zA-Z0-9_\/\-]+)$escaped_postfix|$escaped_replacement\1$escaped_postfix|g"
    elif [[ $1 == "postfix" ]]; then
        echo "option 2"
        -e "s|$escaped_prefix([a-zA-Z0-9_\/\-]+)$escaped_postfix|$escaped_prefix\1$escaped_replacement|g" {} +
        echo "s|$escaped_prefix([a-zA-Z0-9_\/\-]+)$escaped_postfix|$escaped_prefix\1$escaped_replacement|g"
    else
        echo "First argument should be either 'prefix' or 'postfix'."
        exit 1
    fi
}

replacer "$1" "$2" "$3" "$4"

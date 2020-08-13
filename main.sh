#!usr/bin/env bash

number_of_sites=$(cat list_of_sites | wc -l);

# if number of versions of a site is greater than two, remove the oldest one
prune_versions() {
    for i in {1..$number_of_sites};
    do 
        if [[ $(find . -name "site$i*" | wc -l) -gt 2 ]]; then
            to_be_removed=$(find . -name "site$i*" | sort | head -n1);
            rm $to_be_removed;
        fi
    done
}

get_sites() {
    for i in {1..$number_of_sites};
    do curl $(sed "${i}p;d" list_of_sites) > site$i-$(date +%Y_%m_%d_%H_%M_%S);
    done
}

check_for_differences() {
    for i in {1..$number_of_sites};
    do diff $(ls site$i*);
    if [[ $? -eq 1 ]]; then
        current_site=$(sed "${i}p;d" list_of_sites);
        echo "The site: " $current_site "has been updated";
    fi
    done
}

get_sites
prune_versions
check_for_differences



check_mce_capability() {
    stap -p4 -g -m check_mce_capability.ko check_mce_capability.stp
    if [ $? -ne 0 ] ; then
        echo "Failed to build stap script" >&2
        return 1
    fi
    local cap=$(staprun check_mce_capability.ko | cut -f2 -d' ')
    [ ! "$cap" ] && echo "Failed to retrieve MCE CAPABILITY info. SKIPPED." && return 1
    # check 1 << 24 (MCG_SER_P)
    if [ $[ $cap & 16777216 ] -eq 16777216 ] ; then
        return 0
    else
        echo "MCE_SER_P is cleared in the current system."
        return 1
    fi
}
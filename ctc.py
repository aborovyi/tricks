'''
This script monitors chrome RAM activity and kills those tab that overcomes 
defined memory limit.
This program has been tested on:
    python 2.7.8
    psutil 2.1.1

Original source for this program is located at: 
http://superuser.com/questions/413349/limiting-use-of-ram-in-chrome

Modified by wanderlust
'''
import sys, os
try:
    import psutil
except ImportError:
    print "psutil are not installed or not visible for python"
    exit

MEM_LIMIT = 800     # Size of allowed memory for chrome per page
VERBOSE   = True    # Show verbose messages for 

uid = os.getuid()
print "System:", sys.platform
print "Allowed memory for chrome:", str(MEM_LIMIT) + "MB"

while True:

    for p in psutil.get_process_list():
        try: 
            if p.name() == 'chrome' and \
                    any("--type=renderer" in part for part in p.cmdline()) and \
                    p.uids().real == uid:
                # Eliminated all interesting processes
                if sys.platform == "win32" or sys.platform == "cygwin":
                    mem = p.memory_info_ex().num_page_faults / 1024 / 1024
                else:
                    mem = p.memory_info_ex().rss/1024/1024
                if mem > 0.75 * MEM_LIMIT  and VERBOSE:
                    print "Proc: " +  str(p.name()) + " Memory: " + str(mem)
                if mem > MEM_LIMIT:
                    p.kill()
                    if p is None:
                        print "Killed"
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
        



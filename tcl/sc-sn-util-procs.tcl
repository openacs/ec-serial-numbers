ad_library {
    Ecommerce Serial Number Tracking util procs
    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
}

namespace eval sc-sn::util {}

ad_proc sc-sn::util::folder_id {
    -package_id:required
} {
    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18

    Returns the folder_id of the package instance
} {
    return [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]
}
    

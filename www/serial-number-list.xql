<?xml version="1.0"?>
<queryset>

<fullquery name="serial_number">
      <querytext>
      
    select t.*, cr.title, ci.item_id, first_names, last_name
    from cr_folders cf, cr_items ci, cr_revisions cr, ec_serial_numbers t left outer join persons on (persons.person_id = t.owner_id)
    where cr.revision_id = ci.latest_revision
    and t.serial_id = cr.revision_id
    and ci.parent_id = cf.folder_id
    and cf.package_id = :package_id
    [template::list::filter_where_clauses -and -name "serial_number"]
    and [template::list::page_where_clause -name "serial_number"]
    [template::list::orderby_clause -orderby -name "serial_number"]
    
      </querytext>
</fullquery>

<fullquery name="serial_number_pagination">
      <querytext>
      
    select t.*, cr.title, ci.item_id, first_names, last_name
    from cr_folders cf, cr_items ci, cr_revisions cr, ec_serial_numbers t left outer join persons on (persons.person_id = t.owner_id)
    where cr.revision_id = ci.latest_revision
    and t.serial_id = cr.revision_id
    and ci.parent_id = cf.folder_id
    and cf.package_id = :package_id
    [template::list::filter_where_clauses -and -name "serial_number"]
    [template::list::orderby_clause -orderby -name "serial_number"]
    
      </querytext>
</fullquery>

</queryset>
    

<?xml version="1.0"?>
<queryset>

<fullquery name="get_data">
      <querytext>

	select r.title, t.license_key, t.start_date, t.end_date, t.owner_id, t.software_id
	from ec_serial_numbers t, cr_revisions r, cr_items i
	where r.revision_id = t.serial_id
	and i.latest_revision = r.revision_id
	and r.item_id = :serial_id

      </querytext>
</fullquery>

</queryset>
    

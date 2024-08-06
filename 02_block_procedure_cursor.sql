DO $$   <<first_block>>
DECLARE
	rec_data RECORD;
	cur_data CURSOR FOR	
	select a.id, b.db_type, a.length from one.field a
	join one.field_type b on a.field_type_id = b.id
	where b.db_type = 'varchar';
	BEGIN
		OPEN cur_data;
		LOOP
		FETCH cur_data INTO rec_data;
		EXIT WHEN NOT FOUND;
	 		RAISE NOTICE '%', rec_data.id;
			UPDATE one.field set length = 255
			where id = rec_data.id;
		END LOOP;
END first_block $$;
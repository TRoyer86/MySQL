-- 1. Provide names and phones of all swimmers currently in level 3

select s.FName, s.LName, s.Phone
from swimmer s
where s.CurrentLevelId = 3;

-- 2. Names of swimmers who have signed up for even '100M Butterfly'
-- of meet id 1

select s.FName, s.LName
from swimmer s, event e, participation p
where s.SwimmerId = p.SwimmerId
and e.EventId = p.EventId
and e.Title = '100M Butterfly'
and e.MeetId = 1;

-- 3. Provide names of all secondary caretakers of level 2 swimmers

select distinct c.FName, c.LName
from caretaker c, othercaretaker o, swimmer s
where o.CT_Id = c.CT_Id
and s.SwimmerId = o.SwimmerId in
	(select distinct s.SwimmerId
	from swimmer s
	where CurrentLevelId = 2);
	
-- 4. Provide the name of caretakers who are the primary caretakers
-- of at least two swimmers

select c.FName, c.LName
from caretaker c, swimmer s 
where c.CT_Id = s.Main_CT_Id
having count(s.Main_CT_Id) > 1;

-- 5. List names of all caretakers who volunteered for the task
-- 'Recording' but not the task 'Officiating'.

-- first select all caretakers who volunteered for Recording
-- CT_Ids are 1, 2, 3, 4, 5

select distinct c.FName, c.LName 
from caretaker c, v_task v, commitment com
where c.CT_Id = com.CT_Id
and v.VT_Id = com.VT_Id
and v.Name = 'Recording';

-- then select all caretakers who volunteered for Officiating
-- CT_Ids are 1, 4, 5
select distinct c.FName, c.LName 
from caretaker c, v_task v, commitment com
where c.CT_Id = com.CT_Id
and v.VT_Id = com.VT_Id
and v.Name = 'Officiating';

-- subtract the 'Officiating' subset from the 'Recording' subset
select distinct c1.FName, c1.LName
from caretaker c1, v_task v1, commitment com1
where c1.CT_Id = com1.CT_Id
and v1.VT_Id = com1.VT_Id
and v1.Name = 'Recording'
and c1.CT_Id not in
	(select distinct c2.CT_Id
	 from caretaker c2, v_task v2, commitment com2
	 where c2.CT_Id = com2.CT_Id
	 and v2.VT_Id = com2.VT_Id
	 and v2.Name = 'Officiating');

-- 6. Show the number of tasks volunteered by caretakers in descendant order
-- with the names of the caretakers. This counts all commitments.
select distinct concat(c.FName, ' ',c.LName) as 'caretaker', count(com.CT_Id) as 'number of tasks volunteered'
from caretaker c, commitment com
where c.CT_Id = com.CT_Id
group by com.CT_Id
order by count(*) desc;

-- 7. For every swimmer, provide name, primary caretaker name, current level,
-- signed up meet names, dates, and events as
-- | swimmer | caretaker | level | meet | meet date | event |
select distinct concat(s.FName, ' ',s.LName) as swimmer, concat(c.FName, ' ',c.LName) as caretaker, 
l.Level as 'level', m.Title as 'meet', m.Date as 'meet date', e.Title as 'event'
from swimmer s, caretaker c, level l, meet m, event e, participation p
where s.SwimmerId = p.SwimmerId
and p.EventId = e.EventId
and e.MeetId = m.MeetId
and s.CurrentLevelId = l.LevelId
and s.Main_CT_Id = c.CT_Id
order by s.FName asc, m.VenueId asc;





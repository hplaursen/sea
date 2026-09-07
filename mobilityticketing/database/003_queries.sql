select
    t.id,
    t.scheduled_departure_utc,
    t.status
from trips t
where t.route_id = 'LINE-5C'
  and t.scheduled_departure_utc >= '2024-06-01 00:00:00+00'
order by t.scheduled_departure_utc
limit 20;

-- Ordered stops for a specific route
select
    rs.stop_sequence,
    s.id as stop_id, 
    s.city_id, 
    s.name
from stops s 
join route_stops rs on s.id = rs.stop_id
where rs.route_id = 'LINE-5C'
order by rs.stop_sequence;

-- All routes with the number of trips for each route
select
    r.id as route_id,
    r.short_name,
    count(t.id) as number_of_trips
from routes r 
left join trips t on r.id = t.route_id
group by r.id, r.short_name;


select * from routes
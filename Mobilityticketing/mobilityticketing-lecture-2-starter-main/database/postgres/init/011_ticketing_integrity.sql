/*
Capacity cannot be negative. 
Reserved seats cannot be negative or greater than capacity.
Ticket price and payment amount cannot be negative.
Currency must be present and consistently represented.
Ticket codes must support unambiguous lookup.
A payment must refer to an existing ticket.
A validation must refer to an existing ticket.
A ticket validity end cannot be earlier than its start.
Status values must come from a known set.
An external payment reference should not be recorded twice if it represents one captured payment.
*/

begin;

alter table trips
    alter column capacity set not null,
    alter column reserved_seats set not null,
    add constraint trips_capacity_non_negative
        check (capacity >= 0),
    add constraint trips_reserved_seats_valid
        check (reserved_seats between 0 and capacity);

alter table products
    alter column name set not null,
    alter column price set not null,
    alter column currency set not null,
    add constraint currency_format
        check (currency in ('EUR', 'USD', 'DKK')),
    add constraint products_price_non_negative
        check (price >= 0);

alter table users
    alter column is_disabled set not null;

alter table tickets
    alter column user_id set not null, 
    alter column trip_id set not null,
    alter column status set not null,
    alter column status set default 'Pending',
    alter column product_code set not null,
    alter column currency set not null,
    alter column valid_from_utc set not null,
    alter column valid_to_utc set not null,
    alter column price set not null,
    alter column currency set not null,

    add constraint tickets_user_fk
        foreign key (user_id) references users(id),
    add constraint tickets_trip_fk
        foreign key (trip_id) references trips(id),
    add constraint ticket_code_unique
        unique (ticket_code),
    add constraint ticket_id_code_unique
        unique (id,ticket_code),
    add constraint tickets_status
        check (status in ('Pending','Active','Validated','Cancelled','Expired')),
    add constraint product_code_fk
        foreign key (product_code) references products(code),
    add constraint tickets_validity_window
        check (valid_to_utc > valid_from_utc),
    add constraint tickets_price_non_negative
        check (price >= 0),
    add constraint tickets_currency_format
        check (currency in ('EUR', 'USD', 'DKK'));

alter table payments
    alter column user_id set not null,
    alter column ticket_id set not null,
    alter external_payment_reference set not null,
    alter amount set not null,
    alter column currency set not null,
    alter column status set not null,
    alter column status set default 'Pending',
    alter column created_utc set not null,
  
    add constraint payments_user_fk
        foreign key (user_id) references users(id),
    add constraint payments_ticket_fk
        foreign key (ticket_id) references tickets(id),
    add constraint payments_external_payment_reference_unique
        unique (external_payment_reference),
    add constraint payments_amount_non_negative
        check (amount >= 0),
    add constraint payments_currency_format
        check (currency in ('EUR', 'USD', 'DKK')),
    add constraint payments_status
        check (status in ('Pending', 'Captured', 'Failed', 'Refunded'));

alter table validations
    alter column ticket_id set not null,
    alter column ticket_code set not null,
    --alter column vehicle_id set not null,
    alter column stop_id set not null,
    --alter column device_id set not null,
    alter column result set not null,
    alter column validated_utc set not null,

    add constraint validations_ticket_fk
        foreign key (ticket_id, ticket_code) references tickets(id, ticket_code),
    add constraint validations_stop_fk
        foreign key (stop_id) references stops(id);

-- TODO: product reference, ticket-code identity, status, price,
-- currency, validity window and remaining foreign keys.
-- Decide how duplicated validations.ticket_code should be protected.
-- Name every constraint so tests and later migrations can identify it.

commit;

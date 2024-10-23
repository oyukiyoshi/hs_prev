begin;
create table if not exists sentence (
    sentence_id     smallserial     primary key,
    sentence_name   text            not null,
    changed_at      timestamptz     not null
);
create table if not exists tag (
    tag_id      smallserial primary key,
    tag_color   char(6)     not null,
    tag_name    text        not null
);
create table if not exists passage (
    sentence_id     int,
    line_no         int             not null,
    tag_id          int             not null,
    text_type       varchar(4)      not null,
    passage_content text,
    primary key (sentence_id, line_no),
    foreign key (sentence_id) references sentence(sentence_id),
    foreign key (tag_id) references tag(tag_id)
);
commit;
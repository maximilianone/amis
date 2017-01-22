create table Users(
user_login varchar(256),
user_name varchar(256),
user_password varchar(256),
user_telephon varchar(256),
user_email varchar(256),
user_role number,
fk_admin_login varchar(256)
);

create table Book(
book_name varchar(256),
book_author varchar (256), 
book_publisher varchar (256), 
book_section varchar (256), 
book_quantity number,
fk_admin_login varchar(256)
);

create table IssuesRecordings(
fk_user_login varchar(256),
fk_book_name varchar(256),
fk_book_publisher varchar(256),
status varchar(256),
date_of_issue date ,
date_of_return date
);


ALTER TABLE users
ADD PRIMARY KEY (user_login);

ALTER TABLE users
ADD FOREIGN KEY (fk_admin_login)
REFERENCES users(user_login);

ALTER TABLE book
ADD constraint book_pk PRIMARY KEY (book_name, book_publisher);

ALTER TABLE book
ADD FOREIGN KEY (fk_admin_login)
REFERENCES users(user_login);

ALTER TABLE IssuesRecordings
ADD CONSTRAINT IssuesRecordings_PK PRIMARY KEY (fk_user_login, fk_book_name);

ALTER TABLE IssuesRecordings
ADD FOREIGN KEY (fk_user_login)
REFERENCES users(user_login);

ALTER TABLE IssuesRecordings
ADD FOREIGN KEY (fk_book_name, fk_book_publisher)
REFERENCES book(book_name, book_publisher);

create table IssuesRecordings_history(
fk_user_login varchar(256),
fk_book_name varchar(256),
fk_book_publisher varchar(256),
status varchar(256),
date_of_issue date,
date_of_return date,
changetime timestamp,
action varchar(10)
);
  
ALTER TABLE IssuesRecordings_history
  ADD CONSTRAINT IssuesRecordingshistory_PK PRIMARY KEY (fk_user_login, changetime);

create view Users_KPI as
select user_login, user_name, user_password, user_telephon, user_email, user_role
from users;

create view book_KPI as
select book_name, book_author, book_publisher, book_section, book_quantity
from book;

create view recordings_KPI as
select fk_user_login ,fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return
from issuesrecordings;

create view recordings_history_KPI as
select fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return, changetime, action
from IssuesRecordings_history;

create or replace
trigger IssuesRecordingsCHANGETRIGGER 
BEFORE INSERT OR DELETE OR UPDATE ON IssuesRecordings
FOR EACH ROW 
BEGIN
  IF INSERTING THEN
    INSERT INTO IssuesRecordings_history(fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return, changetime, action)
      VALUES (:NEW.fk_user_login, :NEW.fk_book_name, :NEW.fk_book_publisher, :NEW.status, :NEW.date_of_issue, :NEW.date_of_return, SYSTIMESTAMP, 'insert');
  END IF;
  IF UPDATING THEN
    INSERT INTO IssuesRecordings_history(fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return, changetime, action)
      VALUES (:NEW.fk_user_login, :NEW.fk_book_name, :NEW.fk_book_publisher, :NEW.status, :NEW.date_of_issue, :NEW.date_of_return, SYSTIMESTAMP, 'update');
  END IF;
  IF DELETING THEN
    INSERT INTO IssuesRecordings_history(fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return, changetime, action)
      VALUES (:OLD.fk_user_login, :OLD.fk_book_name, :OLD.fk_book_publisher, :OLD.status, :OLD.date_of_issue, :OLD.date_of_return, SYSTIMESTAMP, 'delete');
  END IF;
END;
/

create or replace
PROCEDURE add_user(user_login in varchar, user_name in varchar, user_password in varchar, user_telephon in varchar, user_email in varchar, user_role in number, fk_admin_login in varchar, add_result out varchar)
iS user_quantity number;
user_email_quantity number;
   BEGIN
set transaction isolation level serializable;
    Select count(user_login)
      into user_quantity
      from users_KPI
      where users_KPI.user_login=add_user.user_login;
    Select count(user_email)
      into user_email_quantity
      from users_KPI
      where users_KPI.user_email=add_user.user_email;
    if user_quantity<1 then
      if user_email_quantity<1 then
        insert into users(user_login, user_name, user_password, user_telephon, user_email, user_role, fk_admin_login)
        values (add_user.user_login, add_user.user_name, add_user.user_password, add_user.user_telephon, add_user.user_email, add_user.user_role, add_user.fk_admin_login);
        add_result:='success';
      else 
        add_result:='email occupied';
      end if;
    else 
      add_result:='login occupied';
    end if;
   END add_user;
/

create or replace
PROCEDURE add_book(book_name in varchar, book_author in varchar, book_publisher in varchar, book_section in varchar, book_quantity in number, fk_admin_login in varchar, add_book_result out varchar)
iS books_quantity number;
   BEGIN
set transaction isolation level serializable;
    Select count(book_name)
      into books_quantity
      from book_KPI
      where book_KPI.book_name=add_book.book_name and book_KPI.book_publisher=add_book.book_publisher;
    if books_quantity<1 then
      insert into book(book_name, book_author, book_publisher, book_section, book_quantity, fk_admin_login)
      values (add_book.book_name, add_book.book_author, add_book.book_publisher, add_book.book_section, add_book.book_quantity, add_book.fk_admin_login);
      add_book_result:='success';
    else
      update book
      set book_quantity=book_quantity+add_book.book_quantity
      where book.book_name=add_book.book_name and book.book_publisher=add_book.book_publisher;
      add_book_result:='success';
    end if;	
   END add_book;
/

create or replace
PROCEDURE add_record(fk_user_login in varchar, fk_book_name in varchar, fk_book_publisher in varchar, status in varchar, date_of_issue in date, date_of_return in date,  add_record_result out varchar)
iS records_quantity number;
books_quantity number;
exist_quantity number;
   BEGIN
set transaction isolation level read committed;
    Select count(fk_user_login)
      into records_quantity
      from recordings_KPI
      where recordings_KPI.fk_book_name=add_record.fk_book_name and recordings_KPI.fk_user_login=add_record.fk_user_login 
      and recordings_KPI.fk_book_publisher=add_record.fk_book_publisher;
    Select sum(book_quantity) 
      into books_quantity
      from book_kpi
      where book_KPI.book_name=add_record.fk_book_name 
      and book_KPI.book_publisher=add_record.fk_book_publisher;
    SELECT count(book_name)
    into exist_quantity
    from book_kpi
    where book_name=add_record.fk_book_name 
    and book_publisher=add_record.fk_book_publisher;
    if exist_quantity>0 then
      if records_quantity<1 then
        if books_quantity>0 then
          insert into issuesrecordings(fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return)
          values (add_record.fk_user_login, add_record.fk_book_name, add_record.fk_book_publisher, add_record.status, add_record.date_of_issue, add_record.date_of_return);
          update book
          set book_quantity=book_quantity - 1
          where book.book_name=add_record.fk_book_name 
        and book.book_publisher=add_record.fk_book_publisher;
          add_record_result:='success';
        else
          add_record_result:='no free books';
        end if;
      else
      add_record_result:='already loaned';
    end if;
    else 
    add_record_result:='no such book';
    end if;
	
   END add_record;
/

create or replace PROCEDURE return_book(user_login in varchar, book_name in varchar, book_publisher in varchar, return_result out varchar)
as
   BEGIN
	set transaction isolation level serializable;
      update book
      set book_quantity=book_quantity + 1
        where book.book_name=return_book.book_name 
        and book.book_publisher=return_book.book_publisher;
        Delete from IssuesRecordings
          where IssuesRecordings.fk_book_name=return_book.book_name 
          and IssuesRecordings.fk_book_publisher=return_book.book_publisher
          and IssuesRecordings.fk_user_login=return_book.user_login;
        return_result:='success';

   END return_book;
/

create or replace
PROCEDURE authorization_u(user_login in varchar, user_password in varchar, auth_result out varchar, u_role out number)
is auth_u_quantity number;
   BEGIN
    set transaction isolation level serializable;
    Select count(user_login)
      into auth_u_quantity
      from users_KPI
      where users_KPI.user_login=authorization_u.user_login 
      and users_KPI.user_password=authorization_u.user_password;
    if auth_u_quantity>0 then
      Select sum(user_role)
      into u_role
      from users_KPI
      where users_KPI.user_login=authorization_u.user_login 
      and users_KPI.user_password=authorization_u.user_password;
      auth_result:='success';
    else 
      auth_result:='Invalid login or password';
      u_role:=0;
    end if;

   END authorization_u;

/

create or replace PROCEDURE edit_user(user_login in varchar, user_name in varchar, user_telephon in varchar, edit_result out varchar)
is 
   BEGIN
    set transaction isolation level serializable;
    update users
    set user_name=edit_user.user_name, user_telephon=edit_user.user_telephon
    where user_login=edit_user.user_login;
    edit_result:='success';

   END edit_user;
/

create or replace
PROCEDURE edit_user_pass(user_login in varchar, user_password in varchar, old_password in varchar, edit_pass_result out varchar)
is ed_quan number;
   BEGIN
    set transaction isolation level serializable;
    select count(user_login)
      into ed_quan
      from users_KPI
      where users_KPI.user_login=edit_user_pass.user_login 
      and users_KPI.user_password=edit_user_pass.old_password;
    if ed_quan>0 then
      update users
      set user_password=edit_user_pass.user_password
      where user_login=edit_user_pass.user_login;
      edit_pass_result:='success';
    else
      edit_pass_result:='invalid password';
    end if;

   END edit_user_pass;
/

create or replace PROCEDURE change_status(user_login in varchar, book_name in varchar, book_publisher in varchar, status in varchar, changeof_status out varchar)
is 
   BEGIN
    set transaction isolation level serializable;
    update IssuesRecordings
    set status=change_status.status
    where fk_user_login=change_status.user_login
    and fk_book_name=change_status.book_name
    and fk_book_publisher=change_status.book_publisher;
    changeof_status:='success';

   END change_status;
/                                                        

create or replace PROCEDURE change_role(user_login in varchar, user_role in number, role_change out varchar)
is 
   BEGIN
    set transaction isolation level serializable;
    update users
    set user_role=change_role.user_role
    where user_login=change_role.user_login;
    role_change:='success';

   END change_role;
/



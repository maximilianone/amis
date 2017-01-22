insert into users(user_login, user_name, user_password, user_telephon, user_email, user_role)
values ('garret', 'Child Garret', 'garret1', '+380964982112', 'childGarret@mail.com', 3);
insert into users(user_login, user_name, user_password, user_telephon, user_email, user_role, fk_admin_login)
values ('Drizt', 'Drizd do Urden', 'darkelf', '+380749826127', 'darkelf@mail.com', 1, 'garret');


insert into book(book_name, book_author, book_publisher, book_section, book_quantity, fk_admin_login)
values ('Don Quixote', 'Miguel de Cervantes', 'RELX Group', 'fiction', 1, 'garret');
insert into book(book_name, book_author, book_publisher, book_section, book_quantity, fk_admin_login)
values ('A Tale of Two Cities', 'Charles Dickens', 'Wolters Kluwer', 'fiction', 2, 'garret');
insert into book(book_name, book_author, book_publisher, book_section, book_quantity, fk_admin_login)
values ('The Lord of the Rings', 'J.R.R. Tolkien', 'Holtzbrinck', 'fiction', 1, 'garret');


insert into IssuesRecordings(fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return)
values ('Drizt', 'The Lord of the Rings', 'Holtzbrinck', 'reserved','11-dec-16', '2-jan-16');
insert into IssuesRecordings(fk_user_login, fk_book_name, fk_book_publisher, status, date_of_issue, date_of_return)
values ('Drizt', 'A Tale of Two Cities', 'Wolters Kluwer', 'reserved','11-dec-16', '2-jan-16');
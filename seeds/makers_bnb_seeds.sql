
-- DROP DATABASE IF EXISTS makersbnb;
-- CREATE DATABASE IF NOT EXISTS makersbnb;

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP TABLE IF EXISTS requests;

CREATE SEQUENCE IF NOT EXISTS users_id_seq;
CREATE SEQUENCE IF NOT EXISTS properties_id_seq;
CREATE SEQUENCE IF NOT EXISTS requests_id_seq;


CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT, email TEXT, profile_picture_path TEXT, password TEXT);
CREATE TABLE properties (id SERIAL PRIMARY KEY, name TEXT, location TEXT, description TEXT, price DECIMAL, availability BOOLEAN, user_id INT, CONSTRAINT fk_users FOREIGN KEY(user_id) REFERENCES users(id));
CREATE TABLE requests (id SERIAL PRIMARY KEY, booker_id INT, lister_id INT, property_id INT, date DATE, confirmed INTEGER, CONSTRAINT fk_booker_id FOREIGN KEY (booker_id) REFERENCES users(id), CONSTRAINT fk_lister_id FOREIGN KEY(lister_id) REFERENCES users(id), CONSTRAINT fk_property_id FOREIGN KEY(property_id) REFERENCES properties(id));

INSERT INTO users (name, email, profile_picture_path, password) VALUES ('Shaun', 'shaunho@gmail.com','/img/Shaun.jpeg', 'password'), ('Irina', 'irina@gmail.com','/img/Irina.jpg', 'irinas password'), ('Delphine', 'delphine@gmail.com','/img/Delphine.png', 'delphines password'), ('Arsenii', 'arsenii@gmail.com','/img/Arsenii.jpg', 'arseniis password');
INSERT INTO properties (name, location, description, price, availability, user_id) VALUES ('house1', 'place1','description1', 9.99, TRUE, 1), ('house2', 'place2','description2', 12.99, TRUE, 2), ('house3', 'place3','description3', 13.99, TRUE, 3), ('house4', 'place4','description4', 14.99, TRUE, 4), ('house5', 'place5','description5',15.99,  TRUE, 1);
INSERT INTO requests (booker_id, lister_id, property_id, date, confirmed) VALUES (1,2,2,'2011-12-05', 2), (1,3,3, '2011-11-05',2), (1,3,3, '2011-11-05',2), (1,4,4,'2011-12-05', 2);


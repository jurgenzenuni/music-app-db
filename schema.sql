CREATE TABLE "plans" (
  plan_id SERIAL NOT NULL PRIMARY KEY,
  plan_name TEXT NOT NULL,
  price_monthly MONEY NULL,
  price_yearly MONEY NULL,
  is_active BOOLEAN NULL,
  created_at TIMESTAMPTZ NULL
);

CREATE TABLE "users" (
  id SERIAL NOT NULL PRIMARY KEY,
  firstname TEXT NULL,
  lastname TEXT NULL,
  username VARCHAR(25) NULL UNIQUE,
  email TEXT NULL,
  password VARCHAR(100) NULL
);

CREATE TABLE "users_follows_users" (
  follower_id INTEGER NOT NULL,
  following_id INTEGER NOT NULL,
  followed_at TIMESTAMPTZ NULL,
  PRIMARY KEY ("follower_id", "following_id"),
  FOREIGN KEY ("follower_id") REFERENCES "users" ("id"),
  FOREIGN KEY ("following_id") REFERENCES "users" ("id")
);

CREATE TABLE "playlists" (
  id SERIAL NOT NULL PRIMARY KEY,
  creator_id INTEGER NULL,
  playlist_name TEXT NULL,
  is_public BOOLEAN NULL,
  FOREIGN KEY ("creator_id") REFERENCES "users" ("id")
);

CREATE TABLE "artists" (
  id SERIAL NOT NULL PRIMARY KEY,
  name TEXT NULL,
  user_id INTEGER NULL,
  artist_photo BYTEA NULL,
  about_info TEXT NULL,
  genres TEXT NULL,
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

CREATE TABLE "subs" (
  sub_id SERIAL NOT NULL PRIMARY KEY,
  user_id INTEGER NULL,
  plan_id INTEGER NULL,
  status VARCHAR(20) NULL DEFAULT 'active',
  started_at TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMPTZ NULL,
  cancelled_at TIMESTAMPTZ NULL,
  FOREIGN KEY ("plan_id") REFERENCES "plans" ("plan_id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

CREATE TABLE "user_follows_artists" (
  user_id INTEGER NOT NULL,
  artist_id INTEGER NOT NULL,
  followed_at TIMESTAMPTZ NULL,
  PRIMARY KEY ("user_id", "artist_id"),
  FOREIGN KEY ("artist_id") REFERENCES "artists" ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

CREATE TABLE "albums" (
  id SERIAL NOT NULL PRIMARY KEY,
  artist_id INTEGER NULL,
  album_name TEXT NULL,
  genre TEXT NULL,
  FOREIGN KEY ("artist_id") REFERENCES "artists" ("id")
);

CREATE INDEX "idx_album_artistid" ON "albums" ("artist_id");

CREATE TABLE "songs" (
  id SERIAL NOT NULL PRIMARY KEY,
  song_name TEXT NULL,
  genre TEXT NULL,
  artist_id INTEGER NULL,
  album_id INTEGER NULL,
  length INTEGER NULL,
  FOREIGN KEY ("album_id") REFERENCES "albums" ("id"),
  FOREIGN KEY ("artist_id") REFERENCES "artists" ("id")
);

CREATE INDEX "idx_song_artistid" ON "songs" ("artist_id");

CREATE INDEX "idx_song_albumid" ON "songs" ("album_id");

CREATE TABLE "listening_history" (
  id SERIAL NOT NULL PRIMARY KEY,
  user_id INTEGER NULL,
  song_id INTEGER NULL,
  played_at TIMESTAMPTZ NULL,
  duration_played INTEGER NULL,
  device TEXT NULL,
  FOREIGN KEY ("song_id") REFERENCES "songs" ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

CREATE INDEX "idx_history_userid" ON "listening_history" ("user_id");

CREATE INDEX "idx_history_songid" ON "listening_history" ("song_id");

CREATE TABLE "list_content" (
  playlist_id INTEGER NOT NULL,
  song_id INTEGER NOT NULL,
  added_at TIMESTAMPTZ NULL,
  position INTEGER NULL,
  PRIMARY KEY ("playlist_id", "song_id"),
  FOREIGN KEY ("playlist_id") REFERENCES "playlists" ("id"),
  FOREIGN KEY ("song_id") REFERENCES "songs" ("id")
)

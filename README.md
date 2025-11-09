# 🎵 Music Streaming Database Schema

A comprehensive PostgreSQL database schema design for a music streaming platform (Spotify-like), featuring user subscriptions, artist catalogs, playlists, and social features.

## 📊 Entity-Relationship Diagram

![Music Streaming Database ERD](music-app-schema-img.png)

---

## 📋 Project Overview

This project demonstrates advanced database design concepts including:
- Entity-Relationship Diagram (ERD) modeling
- Complex many-to-many relationships with junction tables
- Self-referential relationships for social features
- Proper normalization and foreign key constraints
- Strategic indexing for query optimization

**Key Features:**
- User authentication and subscription management
- Artist profiles with albums and tracks
- User-created playlists with collaborative options
- Listening history tracking for analytics
- Social features (follow users and artists)

## 🗂️ Database Structure

### Tables Overview
- **plans** - Subscription tier definitions (free, basic, premium)
- **users** - User account information
- **subs** - Subscription history with lifecycle tracking
- **artists** - Artist profiles and metadata
- **albums** - Album catalog
- **songs** - Track library with duration and genre
- **playlists** - User-created playlists
- **list_content** - Junction table: playlists ↔ songs (many-to-many)
- **listening_history** - User play tracking for analytics
- **users_follows_users** - Junction table: user following (self-referential)
- **user_follows_artists** - Junction table: users ↔ artists (many-to-many)

### Relationships
- **One-to-Many:** Users → Playlists, Artists → Albums, Albums → Songs, Plans → Subscriptions
- **Many-to-Many:** Playlists ↔ Songs, Users ↔ Artists, Users ↔ Users (following)
- **Self-Referential:** Users following other users

## 🛠️ Technologies Used

- **Database:** PostgreSQL
- **Schema Design:** ERD modeling with crow's foot notation
- **Data Types:** SERIAL, INTEGER, TEXT, VARCHAR, MONEY, BOOLEAN, TIMESTAMPTZ, BYTEA

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 12 or higher
- psql or pgAdmin for database management

### Installation

1. Clone this repository:
git clone https://github.com/yourusername/music-streaming-database-schema.git
cd music-streaming-database-schema

text

2. Create a new PostgreSQL database:
createdb music_streaming

text

3. Execute the schema:
psql -d music_streaming -f schema.sql

text

## 🔍 Design Decisions

### Indexing Strategy
Foreign keys are indexed on frequently joined columns:
- `albums.artist_id` - For artist discography queries
- `songs.artist_id` and `songs.album_id` - For music catalog joins
- `listening_history.user_id` and `listening_history.song_id` - For analytics queries

### Composite Primary Keys
Junction tables use composite primary keys instead of surrogate keys:
- Enforces uniqueness at the database level
- More efficient storage and query performance
- Standard best practice for many-to-many relationships

### Subscription History
The `subs` table creates a new row for each subscription period rather than updating existing records:
- Maintains complete audit trail
- Enables churn analysis and resubscription tracking
- Supports subscription upgrades/downgrades

## 📝 Example Queries

Get a user's active subscription:
SELECT u.username, p.plan_name, s.expires_at
FROM users u
JOIN subs s ON u.id = s.user_id
JOIN plans p ON s.plan_id = p.plan_id
WHERE u.id = 1 AND s.status = 'active';

text

Find most played songs:
SELECT s.song_name, a.name as artist, COUNT(*) as play_count
FROM listening_history lh
JOIN songs s ON lh.song_id = s.id
JOIN artists a ON s.artist_id = a.id
GROUP BY s.song_name, a.name
ORDER BY play_count DESC
LIMIT 10;

text

Get all songs in a playlist:
SELECT s.song_name, a.name as artist, s.length
FROM list_content lc
JOIN songs s ON lc.song_id = s.id
JOIN artists a ON s.artist_id = a.id
WHERE lc.playlist_id = 1
ORDER BY lc.position;

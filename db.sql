-- Players
CREATE TABLE players (
    discord_id BIGINT PRIMARY KEY,
    username TEXT,
    avatar_url TEXT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cards
CREATE TABLE cards (
    id SERIAL PRIMARY KEY,
    character_name TEXT NOT NULL,
    form TEXT CHECK (form IN ('base', 'awakened', 'event')),
    series TEXT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    owner_id BIGINT REFERENCES players(discord_id) ON DELETE SET NULL
);

-- Submissions
CREATE TABLE submissions (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    form_type TEXT CHECK (form_type IN ('base', 'awakened', 'event')),
    series TEXT,
    image_url TEXT,
    submitted_by TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teams
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE team_members (
    team_id INTEGER REFERENCES teams(id) ON DELETE CASCADE,
    discord_id BIGINT REFERENCES players(discord_id) ON DELETE CASCADE,
    role TEXT DEFAULT 'member',
    PRIMARY KEY (team_id, discord_id)
);

-- Market
CREATE TABLE market_listings (
    id SERIAL PRIMARY KEY,
    card_id INTEGER REFERENCES cards(id) ON DELETE CASCADE,
    seller_id BIGINT REFERENCES players(discord_id),
    price INTEGER,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'sold', 'cancelled')),
    listed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

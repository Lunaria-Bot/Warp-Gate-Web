from quart import Blueprint, render_template, current_app

player_bp = Blueprint("player", __name__)
player_bp.db_pool = None  # injecté dans app.py

@player_bp.route("/profile/<int:player_id>")
async def profile(player_id):
    pool = current_app.config["DB_POOL"]
    async with pool.acquire() as conn:
        player = await conn.fetchrow("SELECT * FROM players WHERE discord_id = $1", player_id)
        cards = await conn.fetch("SELECT * FROM cards WHERE owner_id = $1", player_id)

    if not player:
        return "Player not found", 404

    stats = {
        "total": len(cards),
        "base": sum(1 for c in cards if c["form"] == "base"),
        "awakened": sum(1 for c in cards if c["form"] == "awakened"),
        "event": sum(1 for c in cards if c["form"] == "event"),
    }

    player_data = {
        "discord_id": player["discord_id"],
        "username": player["username"],
        "avatar_url": player["avatar_url"] or "https://cdn.discordapp.com/embed/avatars/0.png",
        "badges": ["Founder", "Beta Tester"]  # à remplacer par une vraie table si besoin
    }

    return await render_template("profile.html", player=player_data, stats=stats, inventory=cards)

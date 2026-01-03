const { onCall } = require("firebase-functions/v2/https");
const axios = require("axios");
const { defineSecret } = require("firebase-functions/params");

const RIOT_API_KEY = defineSecret("RIOT_API_KEY");

exports.verifyValorant = onCall({ secrets: [RIOT_API_KEY] }, async (req) => {
  const { gameName, tagLine, region } = req.data;

  if (!gameName || !tagLine) {
    return { success: false, error: "Missing name or tag" };
  }

  try {
    // 1️⃣ Riot Account API (region = asia / americas / europe)
    const accountRes = await axios.get(
      `https://${region}.api.riotgames.com/riot/account/v1/accounts/by-riot-id/${encodeURIComponent(gameName)}/${encodeURIComponent(tagLine)}`,
      {
        headers: {
          "X-Riot-Token": RIOT_API_KEY.value(),
        },
      }
    );

    const puuid = accountRes.data.puuid;

    // 2️⃣ Valorant APIs use SHARDS, not regions
    let valorantShard = "ap"; // India, SEA
    if (region === "americas") valorantShard = "na";
    if (region === "europe") valorantShard = "eu";

    const profileRes = await axios.get(
      `https://${valorantShard}.api.riotgames.com/val/competitive/v1/players/${puuid}`,
      {
        headers: {
          "X-Riot-Token": RIOT_API_KEY.value(),
        },
      }
    );

    return {
      success: true,
      puuid: puuid,
      shard: valorantShard,
      competitive: profileRes.data,
    };
  } catch (err) {
    return {
      success: false,
      error: err.response?.data || "Riot ID not found",
    };
  }
});


import { factories } from "@strapi/strapi";

export default factories.createCoreController(
    "api::generate.generate",
    ({ strapi }) => ({
        // GET /api/generate
        async find(ctx) {
        const entries = await strapi.entityService.findMany(
            "api::generate.generate"
        );
        return entries;
        },

        // POST /api/generate
        async createApp(ctx) {
        try {
            const { keyword, color, style } = ctx.request.body;

            if (!keyword) return ctx.badRequest("keyword が必要です");

            const apiKey = process.env.GEMINI_API_KEY;
            if (!apiKey) {
            return ctx.throw(
                500,
                "GEMINI_API_KEY が設定されていません (.env を確認してください)"
            );
        }

        const url = `https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${apiKey}`;

        const prompt = `
あなたはAIアプリ生成エンジンです。以下に基づいてFlutterアプリの概要を日本語で生成してください。

- キーワード: ${keyword}
- カラー: ${color || "指定なし"}
- スタイル: ${style || "指定なし"}

出力:
1. アプリ説明
2. 主な機能
3. コード概要（Widget名含む）
`;

        const body = {
            contents: [
                {
                parts: [{ text: prompt }],
                },
            ],
            };

            const res = await fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(body),
            });

            if (!res.ok) {
            const err = await res.text();
            console.error("❌ Gemini API エラー:", err);
            return ctx.internalServerError(
                "Gemini APIエラー：" + err.substring(0, 400)
            );
            }

            const data: any = await res.json(); // ← 型 unknown 回避のため any にする

            // v1 API の構造に合わせて抽出
            const text =
            data?.candidates?.[0]?.content?.parts?.[0]?.text ??
            "生成に失敗しました。";

            return ctx.send({
            message: "✅ アプリ生成成功",
            data: { keyword, color, style, result: text },
            });
        } catch (error) {
            console.error("❌ Geminiエラー:", error);
            return ctx.internalServerError(
            "Gemini API連携中にエラーが発生しました。"
            );
        }
        },
    })
);

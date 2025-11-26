/**
 * generate controller
 */

import { factories } from "@strapi/strapi";
import { GoogleGenerativeAI } from "@google/generative-ai";

export default factories.createCoreController("api::generate.generate", ({ strapi }) => ({
    
    async generateApp(ctx) {
        try {
        const { keyword, color, style } = ctx.request.body;

        const apiKey = process.env.GEMINI_API_KEY;
        if (!apiKey) {
            return ctx.internalServerError("Gemini APIキーが設定されていません");
        }

        const genAI = new GoogleGenerativeAI(apiKey);

        // ---- モデルは v1 の正式版のみ ----
        const model = genAI.getGenerativeModel({
            model: "models/gemini-2.5-flash",
        });

        const prompt = `
    あなたはノーコードAIアプリ生成エンジンです。
    以下の情報に基づいて、HTML+JSで動作するシンプルなアプリコードを生成してください。

    - キーワード: ${keyword}
    - カラー: ${color}
    - スタイル: ${style}

    出力は必ず <html> ~ </html> の完全なHTML形式で返してください。
        `;

        const result = await model.generateContent({
            contents: [{ role: "user", parts: [{ text: prompt }] }],
        });

        const text = result.response.text();

        return ctx.send({
            message: "✅ アプリ生成成功",
            data: {
                result: `
                <html>
                <head>
                    <meta charset="utf-8" />
                    <style>
                    body { font-family: sans-serif; padding: 20px; }
                    </style>
                </head>
                <body>
                    ${text}
                </body>
                </html>
                `
            }
        });

        } catch (err) {
        console.error("❌ Gemini API エラー:", err);
        return ctx.internalServerError(`Gemini APIエラー：${JSON.stringify(err)}`);
        }
    },

}));

module.exports = {
    routes: [
        {
            method: "POST",
            path: "/generate",
            handler: "generate.createApp",
            config: {
                auth: false,
            },
        },
        {
            method: "GET",
            path: "/generate",
            handler: "generate.find",
            config: {
                auth: false,
            },
        }
    ],
};

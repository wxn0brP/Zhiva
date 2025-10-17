#!/usr/bin/env bun

import { $ } from "bun";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";

const baseLink = `https://github.com/wxn0brP/Zhiva/releases/download/native/`;
const HOME = process.env.HOME;
const zhivaPath = `${HOME}/.zhiva`;
if (!existsSync(zhivaPath)) mkdirSync(zhivaPath);
process.chdir(zhivaPath);

const platform = process.platform;

async function checkEngine() {
    const nv = "zhiva.nv.txt";

    try {
        const serverVersion = await fetch(baseLink + nv).then(res => res.text());
        if (existsSync(nv) && readFileSync(nv, "utf-8").trim() === serverVersion.trim()) return console.log("Zhiva is up to date");

        console.log("Downloading Zhiva...");
        await $`curl -L ${baseLink}zhiva-${platform} -o zhiva`;
        writeFileSync(nv, serverVersion);
        if (platform !== "win32") await $`chmod +x zhiva`;
    } catch (e) {
        console.error("Error downloading/updating Zhiva:", e);
        // if ./zhiva doesn't exist, exit
        if (!existsSync("zhiva")) process.exit(1);
    }
}

await checkEngine();
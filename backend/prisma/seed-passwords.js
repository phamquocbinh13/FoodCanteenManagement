"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = require("dotenv");
const path_1 = require("path");
const argon2 = __importStar(require("argon2"));
const client_1 = require("@prisma/client");
(0, dotenv_1.config)({ path: (0, path_1.resolve)(__dirname, '../.env') });
const DEMO_PASSWORDS = [
    { email: 'admin@demo.local', password: 'admin123' },
    { email: 'manager@demo.local', password: 'manager123' },
    { email: 'cashier@demo.local', password: 'cashier123' },
    { email: 'kitchen@demo.local', password: 'kitchen123' },
    { email: 'shipper@demo.local', password: 'shipper123' },
];
async function main() {
    const prisma = new client_1.PrismaClient();
    try {
        for (const row of DEMO_PASSWORDS) {
            const hash = await argon2.hash(row.password, { type: argon2.argon2id });
            const result = await prisma.staffUser.updateMany({
                where: { email: row.email },
                data: { passwordHash: hash },
            });
            console.log(result.count > 0
                ? `Updated ${row.email}`
                : `SKIP (not found): ${row.email}`);
        }
    }
    finally {
        await prisma.$disconnect();
    }
}
main().catch((err) => {
    console.error(err);
    process.exit(1);
});
//# sourceMappingURL=seed-passwords.js.map
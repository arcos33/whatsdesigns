import { isDevelopment } from './env';

type LogLevel = 'info' | 'warn' | 'error' | 'debug';

interface LogMessage {
  level: LogLevel;
  message: string;
  timestamp: string;
  data?: unknown;
}

type LogData = string | number | boolean | null | undefined | object | unknown[];

class Logger {
  private static instance: Logger;
  private logs: LogMessage[] = [];

  private constructor() {}

  static getInstance(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger();
    }
    return Logger.instance;
  }

  private formatMessage(level: LogLevel, message: string, data?: LogData): LogMessage {
    return {
      level,
      message,
      timestamp: new Date().toISOString(),
      data,
    };
  }

  private log(level: LogLevel, message: string, data?: LogData) {
    const formattedMessage = this.formatMessage(level, message, data);
    this.logs.push(formattedMessage);

    if (isDevelopment) {
      const color = {
        info: '\x1b[36m', // Cyan
        warn: '\x1b[33m', // Yellow
        error: '\x1b[31m', // Red
        debug: '\x1b[35m', // Magenta
      }[level];

      console.log(
        `${color}[${formattedMessage.timestamp}] ${level.toUpperCase()}: ${message}\x1b[0m`,
        data ? data : ''
      );
    }
  }

  info(message: string, data?: LogData) {
    this.log('info', message, data);
  }

  warn(message: string, data?: LogData) {
    this.log('warn', message, data);
  }

  error(message: string, data?: LogData) {
    this.log('error', message, data);
  }

  debug(message: string, data?: LogData) {
    if (isDevelopment) {
      this.log('debug', message, data);
    }
  }

  getLogs(): LogMessage[] {
    return [...this.logs];
  }

  clearLogs() {
    this.logs = [];
  }
}

export const logger = Logger.getInstance(); 
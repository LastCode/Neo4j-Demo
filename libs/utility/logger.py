import logging


class CustomFormatter(logging.Formatter):
    """
    Custom formatter to add colors to log Levels.
    """
    COLORS = {
        "WARNING": "\033[93m",  # Yellow
        "ERROR": "\033[91m",  # Red
        "CRITICAL": "\033[91m",  # Red
        "DEBUG": "\033[92m",  # Green
        "INFO": "\033[97m",  # White
    }
    RESET = "\033[0m"

    def format(self, record):
        log_color = self.COLORS.get(record.levelname, self.RESET)
        message = super().format(record)
        return f"{log_color}{message}{self.RESET}"


def setup_logger():
    """
    Configures the logger for the script with colored output.
    """
    logger = logging.getLogger("DomainCollector")
    logger.setLevel(logging.INFO)  # 改為 INFO

    # 避免重複添加 handler
    if not logger.hasHandlers():
        formatter = CustomFormatter(
            fmt="%(asctime)s - %(levelname)s - %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S"
        )
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        logger.addHandler(console_handler)

    return logger  # 重要：必須返回 logger 物件
